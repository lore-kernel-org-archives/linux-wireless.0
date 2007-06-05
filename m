Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:18401 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763761AbXFEXyP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2007 19:54:15 -0400
From: =?utf-8?q?I=C3=B1aky_P=C3=A9rez-Gonz=C3=A1lez?=
	<inaky.perez-gonzalez@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: RFC: Regulatory info in mac80211
Date: Tue, 5 Jun 2007 16:54:13 -0700
Cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	"Tim Gardner" <tim.gardner@canonical.com>,
	"Marcel Holtmann" <marcel@holtmann.org>,
	"James Ketrenos" <jketreno@linux.intel.com>,
	"Alan Cox" <alan@lxorguk.ukuu.org.uk>,
	"Matt Norwood" <norwood@softwarefreedom.org>
References: <4665CCE7.5090409@lwfinger.net> <43e72e890706051635s4c1d0a70p7e334edd8c6b3a38@mail.gmail.com>
In-Reply-To: <43e72e890706051635s4c1d0a70p7e334edd8c6b3a38@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200706051654.13712.inaky.perez-gonzalez@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 05 June 2007, Luis R. Rodriguez wrote:
> On 6/5/07, Larry Finger <Larry.Finger@lwfinger.net> wrote:


> Besides having cfg80211 speak regulatory domains another idea is to
> have a central frequency broker in the kernel so that besides just
> working as a frequency broker for 802.11 regulatory compliance it can
> also enhance interoperability between the different supported radio
> types -- 802.11, bluetooth, ultrawideband (and any other that is added
> to the kernel). This idea is still under development:
> 
> http://linuxwireless.org/en/developers/FrequencyBroker

Which reminds me I have to add a link to the code repos.

Thanks,

-- Inaky
