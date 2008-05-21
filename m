Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.188]:15965 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758208AbYEUT6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 15:58:12 -0400
Received: by gv-out-0910.google.com with SMTP id e6so904063gvc.37
        for <linux-wireless@vger.kernel.org>; Wed, 21 May 2008 12:58:11 -0700 (PDT)
Message-ID: <445f43ac0805211251v12f49c26j540bf3763bc4dd27@mail.gmail.com> (sfid-20080521_215816_450933_4A9640CD)
Date: Wed, 21 May 2008 12:51:20 -0700
From: "Javier Cardona" <javier@cozybit.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [PATCH 2/2] Sysfs interface for accessing non-volatile configuration.
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	carrano@laptop.org, dilinger@queued.net
In-Reply-To: <1211398105.21380.371.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4832422a.20018e0a.6b37.3217@mx.google.com>
	 <1211292718.21380.238.camel@pmac.infradead.org>
	 <445f43ac0805211159u317bf720vd88d29a504445ba6@mail.gmail.com>
	 <1211396780.21380.368.camel@pmac.infradead.org>
	 <445f43ac0805211218v58d33458v41d0d11f98ed4f14@mail.gmail.com>
	 <1211398105.21380.371.camel@pmac.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David,

On Wed, May 21, 2008 at 12:28 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Wed, 2008-05-21 at 12:18 -0700, Javier Cardona wrote:
>> You need a live endpoint to send a CMD_802_11_RESET, which you won't
>> have if the device did not respond to USB enumeration because it was
>> in standalone mode.
>
> Hm, did that behaviour change recently? I'm sure this recovery was
> working before.

I don't think we've ever been able to communicate over USB with a
dongle that is in standalone mode.

Javier


-- 
Javier Cardona
cozybit Inc.
