Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:49660 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751081AbXLLVmD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 16:42:03 -0500
Date: Wed, 12 Dec 2007 22:34:28 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [RFC/T][PATCH 1/3] rc80211-pid: introduce rate behaviour
 learning algorithm
Message-ID: <20071212223428.2bde9d6c@morte> (sfid-20071212_214211_901367_8CCEE8E9)
In-Reply-To: <1197489986.7491.11.camel@localhost>
References: <20071209211547.2d7fca32@morte>
	<20071209211931.26ff42fa@morte>
	<1197239150.7543.13.camel@localhost>
	<20071210090853.79ea4645@morte>
	<1197319867.7493.4.camel@localhost>
	<1197384754.4037.23.camel@johannes.berg>
	<1197393788.7528.5.camel@localhost>
	<1197479594.6558.122.camel@johannes.berg>
	<1197489986.7491.11.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 12 Dec 2007 21:06:26 +0100
Mattias Nissler <mattias.nissler@gmx.de> wrote:

> Anyway, I think we don't need any special handling of this situation at
> the moment. The stack needs more nl80211/cfg80211 work anyway, so let's
> fix this once we've fixed the stack.

Agreed.


--
Ciao
Stefano
