Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53508 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535Ab1KWPka (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 10:40:30 -0500
Received: by iage36 with SMTP id e36so1731064iag.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2011 07:40:29 -0800 (PST)
Message-ID: <4ECD13D0.6010500@lwfinger.net> (sfid-20111123_164034_277740_D820CA82)
Date: Wed, 23 Nov 2011 09:40:00 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: =?UTF-8?B?SmFuIER2b8WZw6Fr?= <dvorakj@cngroup.dk>,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8192cu not working with Edimax EW-7811Un
References: <20111122113427.3d332b00776546d5ebac11de@cngroup.dk> <20111122140139.GA3891@redhat.com> <20111123112301.f5e523ff743f86dae539fdf3@cngroup.dk> <20111123143304.GA13460@redhat.com> <20111123162426.9a30d25585fa54507c1c864e@cngroup.dk>
In-Reply-To: <20111123162426.9a30d25585fa54507c1c864e@cngroup.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/23/2011 09:24 AM, Jan Dvořák wrote:
> On Wed, 23 Nov 2011 15:33:05 +0100
> Stanislaw Gruszka<sgruszka@redhat.com>  wrote:
>> Another kernel to test :-)
>> http://koji.fedoraproject.org/koji/taskinfo?taskID=3534603
>
> OK, I have no idea if this is because of the new kernel, but
> client mode works. I can't still use hostapd, however.
>
> So, in hope this does not get old too soon, any ideas? :-)

Stanislaw,

What patches did you put in that koji kernel? I'm not a Fedora user, and I'm not 
sure what base that Jan started with and what updates were needed.

I know that the initial driver had a problem connecting to 802.11n-only 
channels, but this was fixed in wireless-testing some time ago. Is this the patch?

Thanks,

Larry

