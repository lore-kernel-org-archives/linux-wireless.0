Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61731 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab0FMURO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jun 2010 16:17:14 -0400
Received: by pvg16 with SMTP id 16so2312871pvg.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jun 2010 13:17:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTincbrPV9DTY0qIM1iBZ6byvsSV1t84OVoFNZ2Bq@mail.gmail.com>
References: <AANLkTincbrPV9DTY0qIM1iBZ6byvsSV1t84OVoFNZ2Bq@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sun, 13 Jun 2010 13:16:54 -0700
Message-ID: <AANLkTinWtINkUig1AmNldv28CSxD2O2kFChZbv0lwsGa@mail.gmail.com>
Subject: Re: DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 19
To: sundar mahadevan <sundarmahadevan82@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 13, 2010 at 10:08 AM, sundar mahadevan
<sundarmahadevan82@gmail.com> wrote:
> Hi All,
> Greetings. I am on Oracle Enterprise Linux (OEL 5.5 x86_64) same as
> Redhat 5.5. I must use OEL5.5 because of my software installation
> requirements. NetworkManager detects my ssid but its just not getting
> ip from my router assigned. I use a Belkin 54g router with WPA/WPA2
> encryption. The other options available on my router are WPA2 only,
> WEP and Disabled. I have spent more than 20 hours trying to get wifi
> working but no luck. Your help is highly appreciated.
>
> [root@localhost ~]$uname -a
> Linux localhost.localdomain 2.6.18-194.el5 #1 SMP Mon Mar 29 22:10:29
> EDT 2010 x86_64 x86_64 x86_64 GNU/Linux
>
> [root@localhost /etc/wpa_supplicant]$lspci | grep -i ath
> 04:00.0 Network controller: Atheros Communications Inc. AR928X
> Wireless Network Adapter (PCI-Express) (rev 01)

Please see:

http://wireless.kernel.org/en/users/Drivers/ath9k/RHEL5#Known_issues

Seems like the same issue.

  Luis
