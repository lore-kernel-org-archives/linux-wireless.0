Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-156-71.gdrpmi.dsl-w.verizon.net ([71.115.156.71]:51322
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbZBNDRI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 22:17:08 -0500
Message-ID: <499637AB.9010301@erley.org> (sfid-20090214_041712_561200_420443C8)
Date: Fri, 13 Feb 2009 22:16:59 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: compat-wireless with CONFIG_MAC80211disabled
References: <1925ef8a0902130015o6df0c962n3fe05ec420d0aef@mail.gmail.com>	 <43e72e890902130023w3c192b04r3a41b4643eedb530@mail.gmail.com>	 <1925ef8a0902130454i7b72a7fftb13cc6b77413b70c@mail.gmail.com>	 <43e72e890902131449n153b606fne9a6dba1af071915@mail.gmail.com>	 <49962FC9.2040406@erley.org> <43e72e890902131908n3ca09f43w9ac5165b3f03ac66@mail.gmail.com>
In-Reply-To: <43e72e890902131908n3ca09f43w9ac5165b3f03ac66@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
 >> Is there interest in a patch allowing you to
>> set something like FORCE=y on the CLI to override these patches?
> 
> Do you have CONFIG_NET_DMA?
> If not do you have CONFIG_NETWORK_SECMARK?
> 
> It'd be interesting to see what net core is doing due to the rape and
> it'd be even more interesting if we can determine the rape is allowed
> during certain circumstances, therefore allowing us to hack config.mk
> to allow for such atrocities to go on.

Yes to CONFIG_NETWORK_SECMARK, No to CONFIG_NET_DMA.

Pat
