Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p15195424.pureserver.info ([82.165.34.74]:57152 "EHLO
	p15195424.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab3IMJCU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 05:02:20 -0400
Message-ID: <5232D462.6010500@ilande.co.uk> (sfid-20130913_110224_215651_FBE7313D)
Date: Fri, 13 Sep 2013 10:01:22 +0100
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Timothy Rundle <tgrundlesr@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <CALa3VXYo1yTuDr22M7AUcp0WLQszzdMSJczRgmD57uPd_68vWQ@mail.gmail.com> <522D054B.5060205@lwfinger.net> <522DD856.7050309@ilande.co.uk> <522DE1BE.6070904@lwfinger.net> <522DE8CA.9010008@ilande.co.uk> <522DFF83.6000605@lwfinger.net> <522E0573.4000804@ilande.co.uk> <522E1B7D.5010107@lwfinger.net> <522E463E.4040701@ilande.co.uk> <522E5416.4010901@lwfinger.net> <522E5D83.9060103@ilande.co.uk> <522E896E.7000607@lwfinger.net> <522EB51A.2080004@ilande.co.uk> <522F3757.8030600@lwfinger.net> <522F7B61.6060208@ilande.co.uk> <5230CDF1.1040905@lwfinger.net>
In-Reply-To: <5230CDF1.1040905@lwfinger.net>
Subject: Re: RTL8192CU continually reconnecting
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/09/13 21:09, Larry Finger wrote:

> I am now running a kernel built with your configuration. I needed to
> make a couple of changes as it did not have one of the modules my disk
> system needs, and nouveau caused kernel panics, but we are now
> operational. Outside of the whole system being slow due to only one 2.0
> GHz CPU, the wireless connection seems to be stable. At least, there
> have been no disconnects in the first half hour.

Thanks for testing Larry. Last night I finished building an SMP-capable 
kernel with the same configuration and I see no change in behaviour. So 
I think we can rule this out as a possible cause.


ATB,

Mark.
