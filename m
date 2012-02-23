Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52064 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab2BWA73 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 19:59:29 -0500
Received: by iacb35 with SMTP id b35so779769iac.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Feb 2012 16:59:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1329957888.76143.YahooMailClassic@web29502.mail.ird.yahoo.com>
References: <4F457BCD.5020200@lwfinger.net> <1329957888.76143.YahooMailClassic@web29502.mail.ird.yahoo.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 23 Feb 2012 11:59:07 +1100
Message-ID: <CAGRGNgXOjKZQqF_JrAA0hyqcsn8TZWHd9OysqOMrE5_JrmnRjA@mail.gmail.com> (sfid-20120223_015932_878845_5AFE663C)
Subject: Re: [PATCH] rtl8187: Add Ad-hoc mode
To: htl10@users.sourceforge.net
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Attila Fazekas <turul64@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Herton Ronaldo Krzesinski <herton@canonical.com>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Feb 23, 2012 at 11:44, Hin-Tak Leung
<htl10@users.sourceforge.net> wrote:
> --- On Wed, 22/2/12, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> I fixed and tested your patch. With it, I certainly see the
>> beacons and I was
>> able to use NetworkManager to connect once. However, I was
>> never able to ping
>> from either end of the network to the other.
>
> Do you need something manual set-up like "ifconfig wlan1 192.168.0.1" for one box and "ifconfig wlan1 192.168.0.2" for the other box in the IP layer to work? I haven't quite got my head around this one - how network manager agrees for each for go into a private tcp/ip network, given there are three(?) private ranges to use, and setting up host names, and what ip adresses to assign... and since there is no dns for a network of two, it would have to ping by ip address?

If it's anything like how it works on Ubuntu, when you start an Ad-Hoc
network with NetworkManager, it chooses an IP range based on some
internal logic (usually in the 10.0.0.0/8 private network) sets it's
IP to something sensible then starts a DHCP server for everyone else
on the network, so everyone should get a valid IP.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
