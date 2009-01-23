Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:28671 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbZAWTC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 14:02:29 -0500
Received: by mu-out-0910.google.com with SMTP id g7so2979479muf.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 11:02:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <E8FC0565-5438-4AB5-A004-CD31DD9C1AA3@icix.org>
References: <E8FC0565-5438-4AB5-A004-CD31DD9C1AA3@icix.org>
Date: Fri, 23 Jan 2009 11:02:27 -0800
Message-ID: <45e8e6c40901231102y732b6929sce70b00ffcd8bef5@mail.gmail.com> (sfid-20090123_200232_197243_9B8E726B)
Subject: Re: rt2x00 mesh support
From: Andrey Yurovsky <andrey@cozybit.com>
To: Antonio Marques <froz@icix.org>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Antonio.  As I understand it, beaconing is currently broken in
rt2x00 (it used to work in the past).  This means that, until the
device can send beacons again, it won't be able to do mesh (or AP or
IBSS).  However the commit in question at least sets up the driver to
support mesh as soon as beaconing works again.

On Fri, Jan 23, 2009 at 10:58 AM, Antonio Marques <froz@icix.org> wrote:
> Hi,
>
> I have been trying to setup a mesh network using the 802.11s stack, but
> unfortunately the only hardware that I have readily available are rt2x00
> usb dongles and an ath5k mini-pci card. Since support for rt2x00
> driver is listed on o11s.org as being in development, what is the current
> status
> of mesh support for this driver?
>
> I see recent commit activity such as
> fdc26201323eb8ba543ac5624f8d71e55b6f7352,
> "rt2x00: Add mesh support" but I am still unable to establish mesh links
> using
> rt2x00 devices. An rt2x00 device can see the ath5k device according to
> 'iw dev mesh station dump', but the link state never changes to ESTAB.
>
> Thanks,
> Antonio Marques
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
