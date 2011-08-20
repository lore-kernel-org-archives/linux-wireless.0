Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34049 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab1HTNnQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Aug 2011 09:43:16 -0400
Message-ID: <4E4FB9ED.2080707@openwrt.org> (sfid-20110820_154331_206711_16EC79B5)
Date: Sat, 20 Aug 2011 15:43:09 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
Subject: Re: [PATCH] ath9k: remove a bogus WARN_ON
References: <1313252029-17665-1-git-send-email-nbd@openwrt.org> <20110815105146.GA15300@redhat.com>
In-Reply-To: <20110815105146.GA15300@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-15 12:51 PM, Stanislaw Gruszka wrote:
> On Sat, Aug 13, 2011 at 10:13:49AM -0600, Felix Fietkau wrote:
>>  On embedded hardware it's normal to not have a PCI device for the PCI
>>  bridge that the wifi card is attached to. pdev->bus->self will be
>>  NULL in that case. In that case, simply return without emitting an
>>  useless kernel stack trace.
>
> Patch is obviously ok, ACK. However I'm not sure if we should not
> do anything regarding ASPM. Perhaps there is other way to find out
> pcie parent ASPM settings on embedded systems?
I don't think the embedded system that I'm working on even uses ASPM.

- Felix
