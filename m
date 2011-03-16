Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web161604.mail.bf1.yahoo.com ([98.139.210.173]:48584 "HELO
	web161604.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752664Ab1CPRap (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 13:30:45 -0400
Message-ID: <519800.38851.qm@web161604.mail.bf1.yahoo.com>
Date: Wed, 16 Mar 2011 10:24:05 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: rt2800usb stops working with big file transfers in AP and IBSS
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Juan Carlos Garza <juancarlosgarza@gmail.com>
In-Reply-To: <AANLkTik9wfkskAHEpmsm4_gPM0FFBf=q8OVXM99NBRjO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hello
> 
> We have some Ralink RT3071 devices (Delock 88524) and we
> need to
> configure them either as Ad-Hoc or Access Point. In both

Hi,

I have both rt3070 & rt3071 USB dongles, they are notoriously unstable with rt2800usb because of the massive packet loss and duplicate packets - an issue which has not found its solution for over an year. I believe the problem stems from the chip's DMA irregularities.

I think this is exactly why you're experiencing transfer problems, due to packet losses. When you're connected, please try and ping your peer or gateway and confirm if you experience duplicate (DUP!) and/or packet losses as well.

Walter


      
