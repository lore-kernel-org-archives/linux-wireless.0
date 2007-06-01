Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:43765
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762918AbXFAUzY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 16:55:24 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Olivier Cornu" <o.cornu@gmail.com>
Subject: Re: [PATCH] mac80211: Update stop_queues kdoc
Date: Fri, 1 Jun 2007 22:54:59 +0200
Cc: "James Ketrenos" <jketreno@linux.intel.com>,
	"Michael Wu" <flamingice@sourmilk.net>,
	"Jiri Benc" <jbenc@suse.cz>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200706011129.12432.mb@bu3sch.de> <46605814.1090806@linux.intel.com> <7b4bf7ff0706011352h767cc901l2636dfa60d3faaaa@mail.gmail.com>
In-Reply-To: <7b4bf7ff0706011352h767cc901l2636dfa60d3faaaa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200706012254.59629.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 01 June 2007 22:52:38 Olivier Cornu wrote:
>  - stop_queues on the other hand means stop all queues, and this
> should only be needed on stop, reset, etc (why would you stop all
> queues on tx?). In this regard, a single ring device should probably
> still call stop_queues in these contexts.

That's _exactly_ the issue. ;)


-- 
Greetings Michael.
