Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:33178 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbaEWHIP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 03:08:15 -0400
Received: by mail-wg0-f47.google.com with SMTP id x12so4305912wgg.18
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 00:08:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400769683.4174.25.camel@jlt4.sipsolutions.net>
References: <1400767955-16313-1-git-send-email-michal.kazior@tieto.com>
	<1400767955-16313-3-git-send-email-michal.kazior@tieto.com>
	<1400769683.4174.25.camel@jlt4.sipsolutions.net>
Date: Fri, 23 May 2014 09:08:14 +0200
Message-ID: <CA+BoTQmF86L4SCNiqaVd75qUXDSuaAbUzn+JhhCWOywUJboBwA@mail.gmail.com> (sfid-20140523_090819_385758_9F84AA25)
Subject: Re: [PATCH 2/2] ath10k: make core registering async
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 May 2014 16:41, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2014-05-22 at 16:12 +0200, Michal Kazior wrote:
>
>> As a side effect there's no way to propagate
>> registering errors to the pci subsystem but this
>> probably isn't really necessary.
>
> You should probably unbind if it fails - iwlwifi does that.

You mean device_release_driver()? I didn't know about it. Thanks!


Michał
