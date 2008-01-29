Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:7581 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbYA2H1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 02:27:46 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] libertas: trim overly long debug statement
Date: Tue, 29 Jan 2008 08:28:02 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
References: <200801281725.13076.hs4233@mail.mn-solutions.de> <1201538297.14441.3.camel@localhost.localdomain>
In-Reply-To: <1201538297.14441.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200801290828.02279.hs4233@mail.mn-solutions.de> (sfid-20080129_072752_616637_28FA6202)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> If you want to kill them, let's remove them.  // also doesn't
> conform to the kernel style.  I'd say just take the debug bits
> out for now.

Yeah. This "//"-style happens when one becomes too confident and 
don't use checkpatch.pl.
