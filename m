Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49526 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840AbXJOOCR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 10:02:17 -0400
Date: Mon, 15 Oct 2007 07:01:36 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: Anton Blanchard <anton@samba.org>
Cc: yi.zhu@intel.com, jketreno@linux.intel.com,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] jiffies_round -> jiffies_round_relative conversion -
 ipw2100/ipw2200
Message-ID: <20071015070136.2cea656d@laptopd505.fenrus.org> (sfid-20071015_150232_892390_3D51AF3F)
In-Reply-To: <20071015053801.GB3257@kryten>
References: <20071015053428.GA3257@kryten>
	<20071015053801.GB3257@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 15 Oct 2007 00:38:01 -0500
Anton Blanchard <anton@samba.org> wrote:

> 
> When rounding a relative timeout we need to use
> round_jiffies_relative(). 

Acked-by: Arjan van de Ven <arjan@linux.intel.com>
