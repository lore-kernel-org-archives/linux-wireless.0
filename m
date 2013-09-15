Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p15195424.pureserver.info ([82.165.34.74]:33490 "EHLO
	p15195424.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab3IORtE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Sep 2013 13:49:04 -0400
Message-ID: <5235F2D0.6090505@ilande.co.uk> (sfid-20130915_194919_748700_F808CC15)
Date: Sun, 15 Sep 2013 18:48:00 +0100
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Olivier Reuland <olivier@reuland.ch>,
	linux-wireless@vger.kernel.org
References: <CALa3VXYo1yTuDr22M7AUcp0WLQszzdMSJczRgmD57uPd_68vWQ@mail.gmail.com> <522D054B.5060205@lwfinger.net> <522DD856.7050309@ilande.co.uk> <522DE1BE.6070904@lwfinger.net> <522DE8CA.9010008@ilande.co.uk> <522DFF83.6000605@lwfinger.net> <loom.20130915T101439-276@post.gmane.org> <5235BB3B.5030800@lwfinger.net>
In-Reply-To: <5235BB3B.5030800@lwfinger.net>
Subject: Re: RTL8192CU continually reconnecting
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15/09/13 14:50, Larry Finger wrote:

> There is a known problem with the dynamic power management code for this
> chip. Unfortunately, the problem does not affect my system. At the
> moment, my device that uses rtl8192cu has been connected for 12 hours
> with no disconnects. The only evidence of a bug here is poor performance.

Did my email to the list yesterday provide any further clues at all? I 
know that you're looking at re-working the power code, but if there is 
any chance of a stop-gap fix for 3.12 then I know it would be greatly 
appreciated :)


ATB,

Mark.
