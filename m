Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35799 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab1IMSoU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 14:44:20 -0400
Received: by qyk7 with SMTP id 7so756861qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Sep 2011 11:44:19 -0700 (PDT)
Message-ID: <4E6FA480.5030500@lwfinger.net> (sfid-20110913_204423_922213_6BF41A79)
Date: Tue, 13 Sep 2011 13:44:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Francis Moreau <francis.moro@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, gregkh@suse.de
Subject: Re: About the patch: "staging: brcm80211: only enable brcmsmac if
 bcma is not set"
References: <CAC9WiBj0A54_R3NszGBEhzMAiZzL0NBmickE88avp0NDGHyjpg@mail.gmail.com> <CACna6rwQ60viPGssWzBzgtVGBq1xu+AOxb0fqfRq4NaJFcmP=w@mail.gmail.com> <20110913174444.GG11772@tuxdriver.com>
In-Reply-To: <20110913174444.GG11772@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/13/2011 12:44 PM, John W. Linville wrote:
>
> We are going to have to find a way to get brcmsmac into the
> wireless-next tree to make it feasible for the Broadcom guys to get
> bcma support into that driver.  Do you agree?
>
> We could move it under the drivers/net/wireless tree.  Or, maybe I
> could negotiate with Greg to keep it under the drivers/staging tree
> but to let me manage it under wireless-next.  Or...?  Do you have
> any thoughts on this?

Based on the earlier comments, I still see lots of problems in getting brcmsmac 
into the drivers/net/wireless tree; however, the solution where Greg lets you 
manage that part of drivers/staging does not seem to cause too many problems, as 
long as he is kept in the loop. If you could push those changes through Greg 
rather than DaveM, I don't think he would lose any control.

Larry

