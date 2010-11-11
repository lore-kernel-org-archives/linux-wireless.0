Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:41581 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128Ab0KKRpe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 12:45:34 -0500
Subject: Re: Overload Probe Request to send data
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Cassiano Tartari <cassianotartari@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTinDJxnMHEbQjUwWjT2MnW5r7gcxoZW7bZetT7a9@mail.gmail.com>
References: <AANLkTinDJxnMHEbQjUwWjT2MnW5r7gcxoZW7bZetT7a9@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 09:41:16 -0800
Message-ID: <1289497276.12056.91.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-11 at 07:35 -0800, Cassiano Tartari wrote:
> Hi,
> 
>     I'd like to know if somebody could help me giving a way to modify
> the iwlwifi driver to overload the Probe Requests to send data? Which
> file I need to modify, for what word I need search for...
> 
> Thankful,
> 

If you want to do it in iwlwifi, lease take a look at
iwl_fill_probe_req() in iwl-scan.c

But do please aware there is size limitation of the probe request from
uCode.

Wey

