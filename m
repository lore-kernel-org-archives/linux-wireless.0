Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.tglx.de ([62.245.132.106]:59573 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757871AbYCDSWH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 13:22:07 -0500
Date: Tue, 4 Mar 2008 19:20:27 +0100
From: Sebastian Siewior <bigeasy@tglx.de>
To: Dan Williams <dcbw@redhat.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] [NET] libertas: compare the current command with response
Message-ID: <20080304182027.GA23871@www.tglx.de> (sfid-20080304_182211_895233_D15B38D0)
References: <20080304172227.GA14225@www.tglx.de> <1204651390.30024.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <1204651390.30024.19.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Dan Williams | 2008-03-04 12:23:10 [-0500]:

>On Tue, 2008-03-04 at 18:22 +0100, Sebastian Siewior wrote:
>> instead of with itself.
Argh, I mixed up the libertas ml with wireless. Sorry for that.

>Woodhouse already patched this, and Holger submitted woodhouse's patch.
>So I think this is solved.
Holger posted five patches yesterday on the libertas ml, one of them was

|libertas: fix sanity check on sequence number in command
Are you refering to this one? 
This patch fixes the "sequence number compare" but than we still have the
"command compare" which is also comparing with itself.
In case you are talking about another one, than I have overlooked it.

>Dan
Sebastian
