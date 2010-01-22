Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:47715 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754835Ab0AVWmd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 17:42:33 -0500
Message-ID: <4B5A29C3.4080009@redfish-solutions.com>
Date: Fri, 22 Jan 2010 14:42:11 -0800
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	Peter Svensson <petersv@psv.nu>, linux-wireless@vger.kernel.org
Subject: Re: Compat-wireless bleeding-edge daily builds broken since  2009-12-11
References: <Pine.LNX.4.64.0912261245080.5112@cheetah.psv.nu>	 <20091229020027.GE30201@bombadil.infradead.org>	 <4B59FC5E.1020802@redfish-solutions.com>	 <43e72e891001221153w5c4c4bc6g63883b5012d384b7@mail.gmail.com>	 <4B5A20C3.6020304@redfish-solutions.com> <1264198240.9056.4.camel@mj>
In-Reply-To: <1264198240.9056.4.camel@mj>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/22/2010 02:10 PM, Pavel Roskin wrote:
> On Fri, 2010-01-22 at 14:03 -0800, Philip A. Prindeville wrote:
>> Call Trace:
>>  [<d09cb62e>] ieee80211_tx_prepare+0x2ed/0x327 [mac80211]
> 
> I assume it's the hostapd bug that was fixed minutes ago.  Alternatively
> (but less likely), it's a bug in WEP, also fixed today.  Please see the
> current mailing list archives.
> 
> You may want to enable CONFIG_MAC80211_DEBUG_MENU and
> CONFIG_MAC80211_NOINLINE to get more reasonable backtraces.
> 

Yeah, just saw:

"Starting hostapd causes kernel panic"

