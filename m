Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:57589 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbaBVAHG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 19:07:06 -0500
Received: by mail-la0-f53.google.com with SMTP id e16so2949357lan.40
        for <linux-wireless@vger.kernel.org>; Fri, 21 Feb 2014 16:07:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392896671-4288-4-git-send-email-ilan.peer@intel.com>
References: <1392896671-4288-1-git-send-email-ilan.peer@intel.com> <1392896671-4288-4-git-send-email-ilan.peer@intel.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 21 Feb 2014 16:06:44 -0800
Message-ID: <CAB=NE6XzMpuxg5sUiKR=42h1u0iHxibPz1o8_DO_zOQjRoY8Ow@mail.gmail.com> (sfid-20140222_010715_295742_5C65A07D)
Subject: Re: [PATCH v5 3/5] cfg80211: Enable GO operation on additional channels
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 20, 2014 at 3:44 AM, Ilan Peer <ilan.peer@intel.com> wrote:
> +       list_for_each_entry(wdev_iter, &rdev->wdev_list, list) {

This is still my only remaining concern. The Kconfig and documentation
don't point this out and it should if its limited to only trusting
concurrency based on the interfaces from the same driver. If we stick
with this that should be prevalent on the documentation. With that
added you get my:

Reviewed-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

  Luis
