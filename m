Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37936 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455Ab1ESVcW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 17:32:22 -0400
Received: by iwn34 with SMTP id 34so2536803iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2011 14:32:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305396027-5864-1-git-send-email-hauke@hauke-m.de>
References: <1305396027-5864-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 19 May 2011 14:32:02 -0700
Message-ID: <BANLkTiku-uFwVEzoSW96+WOUc75niQ6YwA@mail.gmail.com> (sfid-20110519_233226_043277_85816938)
Subject: Re: [PATCH 1/3] compat-wireless: libertas lbs_pr_<level> was
 converted to pr_<level>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 14, 2011 at 11:00 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This adapt changes in commit f3a57fd148a4afd3c38f558c5b44972cb29ea8ba
> "libertas: Convert lbs_pr_<level> to pr_<level>" to the compat patches.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Cherry picked some hunks as things have changed a bit, sorry for the
delay and thanks for the patch!

 Luis
