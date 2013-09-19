Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p15195424.pureserver.info ([82.165.34.74]:48443 "EHLO
	p15195424.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab3ISGtj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Sep 2013 02:49:39 -0400
Message-ID: <523A9E4A.5060309@ilande.co.uk> (sfid-20130919_084942_813019_A5D383E0)
Date: Thu, 19 Sep 2013 07:48:42 +0100
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
MIME-Version: 1.0
To: Timothy Rundle <tgrundlesr@gmail.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <CALa3VXYo1yTuDr22M7AUcp0WLQszzdMSJczRgmD57uPd_68vWQ@mail.gmail.com> <522D054B.5060205@lwfinger.net> <522DD856.7050309@ilande.co.uk> <522DE1BE.6070904@lwfinger.net> <522DE8CA.9010008@ilande.co.uk> <522DFF83.6000605@lwfinger.net> <522E0573.4000804@ilande.co.uk> <522E1B7D.5010107@lwfinger.net> <522E463E.4040701@ilande.co.uk> <522E5416.4010901@lwfinger.net> <522E5D83.9060103@ilande.co.uk> <522E896E.7000607@lwfinger.net> <522EB51A.2080004@ilande.co.uk> <522F3757.8030600@lwfinger.net> <522F7B61.6060208@ilande.co.uk> <5230CDF1.1040905@lwfinger.net> <CALa3VXbxQ1Z2J5weV7rQ16c53D1MQyDL1YGQrV6EkCJYfh=uYA@mail.gmail.com> <523350DC.5050905@lwfinger.net> <CALa3VXZ2+7v-0xrWgoPsAjaaybfMUDONZae8bSx4XhAc6h7wUw@mail.gmail.com>
In-Reply-To: <CALa3VXZ2+7v-0xrWgoPsAjaaybfMUDONZae8bSx4XhAc6h7wUw@mail.gmail.com>
Subject: Re: RTL8192CU continually reconnecting
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19/09/13 01:42, Timothy Rundle wrote:

> I found that if I setup a old wireless router as a repeater and keep
> it within 10-12 feet I have a stable connection.  If I move it back to
> 12-15 the connection becomes less reliable.  Anything past 15 feet is
> unusable.
>
> I see there have been lots of conversations on the topic and you are
> working on some power management changes.  If you need me to do any
> testing let me know.

Hi Timothy,

Thanks for the information. It's just a hunch at the moment, but is your 
wireless router 802.11b/g only, i.e. it either doesn't have 802.11n 
enabled or doesn't support 802.11n at all?


ATB,

Mark.
