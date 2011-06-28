Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44872 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab1F1Tvy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 15:51:54 -0400
Message-ID: <4E0A30CD.9030006@candelatech.com> (sfid-20110628_215157_847934_593775FA)
Date: Tue, 28 Jun 2011 12:51:41 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michel Alexandre Salim <salimma@fedoraproject.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: Re: [PATCH] ath9k: add module option for disabling 11n functionality
References: <4E0A2F8A.8010102@fedoraproject.org>
In-Reply-To: <4E0A2F8A.8010102@fedoraproject.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/28/2011 12:46 PM, Michel Alexandre Salim wrote:
> Some wireless base stations implement 802.11n mode in ways that
> open-source drivers cannot handle properly, resulting in very unstable
> connections. This patch introduces an '11n_disable' option to the ath9k
> driver, similar to the same option for the iwlagn driver.
>
> Tested at the internal wireless network of www.cs.fau.de, where 802.11n
> currently only works reliably with Windows clients.

Would be lovely if this could be per VIF, and settable through something
dynamic, even if just debugfs or similar....

Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

