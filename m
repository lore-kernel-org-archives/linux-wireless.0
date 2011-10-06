Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56158 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab1JFHML (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 03:12:11 -0400
Received: by ggnv2 with SMTP id v2so1433834ggn.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 00:12:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20111005T122216-407@post.gmane.org>
References: <loom.20111005T122216-407@post.gmane.org>
Date: Thu, 6 Oct 2011 09:12:09 +0200
Message-ID: <CAGXE3d_3NBVta6+QZKN+_c7H+f5fwq+zvfAaFTA7KDugVq6L8A@mail.gmail.com> (sfid-20111006_091214_796836_8F27D74F)
Subject: Re: hostapd with Ralink3060, SSID not visible to STA
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Manish Verma <mail.manishverma@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 5, 2011 at 12:47 PM, Manish Verma
<mail.manishverma@gmail.com> wrote:
> I'm not able to see the SSID configured on my x86 PC using hostapd-0.7.3 with a
> DWA-525 (Dlink N-150) wifi adapter.
> This card has a Ralink's 3060 chipset that is using rt2800pci drivers.
>
> Although hostapd is able to configure the card in AP mode but its SSID is not
> visible to other STAs to connect.
>
>
> I'm using FC15 shipped kernel 2.6.28.6-26.rc1.fc15.i686

2.6.28 is quite old, you could try to use a newer driver version
by using compat-wireless [1].

Helmut

[1] http://linuxwireless.org/en/users/Download
