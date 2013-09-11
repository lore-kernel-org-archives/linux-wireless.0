Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:57772 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054Ab3IKUJX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 16:09:23 -0400
Received: by mail-oa0-f52.google.com with SMTP id f4so9941625oah.11
        for <linux-wireless@vger.kernel.org>; Wed, 11 Sep 2013 13:09:23 -0700 (PDT)
Message-ID: <5230CDF1.1040905@lwfinger.net> (sfid-20130911_220930_973540_39048FA7)
Date: Wed, 11 Sep 2013 15:09:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
CC: Timothy Rundle <tgrundlesr@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: RTL8192CU continually reconnecting
References: <CALa3VXYo1yTuDr22M7AUcp0WLQszzdMSJczRgmD57uPd_68vWQ@mail.gmail.com> <522D054B.5060205@lwfinger.net> <522DD856.7050309@ilande.co.uk> <522DE1BE.6070904@lwfinger.net> <522DE8CA.9010008@ilande.co.uk> <522DFF83.6000605@lwfinger.net> <522E0573.4000804@ilande.co.uk> <522E1B7D.5010107@lwfinger.net> <522E463E.4040701@ilande.co.uk> <522E5416.4010901@lwfinger.net> <522E5D83.9060103@ilande.co.uk> <522E896E.7000607@lwfinger.net> <522EB51A.2080004@ilande.co.uk> <522F3757.8030600@lwfinger.net> <522F7B61.6060208@ilande.co.uk>
In-Reply-To: <522F7B61.6060208@ilande.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/10/2013 03:04 PM, Mark Cave-Ayland wrote:

> Interesting. Perhaps there is something different in the initial programming of
> the radio that causes it to crash on my particular hardware revision? As before,
> please let me know if there is anything else you require.

 From the log data, you have the same revision as I do.

I am now running a kernel built with your configuration. I needed to make a 
couple of changes as it did not have one of the modules my disk system needs, 
and nouveau caused kernel panics, but we are now operational. Outside of the 
whole system being slow due to only one 2.0 GHz CPU, the wireless connection 
seems to be stable. At least, there have been no disconnects in the first half hour.

Larry


