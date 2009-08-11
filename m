Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:53365 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750878AbZHKAkp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 20:40:45 -0400
Message-ID: <4A80BE1F.8020708@snapgear.com>
Date: Tue, 11 Aug 2009 10:41:03 +1000
From: Philip Craig <philipc@snapgear.com>
MIME-Version: 1.0
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
CC: Pavel Roskin <proski@gnu.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Jon Loeliger <jdl@bigfootnetworks.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] CRDA and cross-compilation
References: <4A7A8F7E.6020503@redfish-solutions.com>	 <1249569993.6446.2.camel@jdl-desktop> 	<1249576886.14919.16.camel@mj>	 <43e72e890908060956j3548c23ak4cf98d11c32efec0@mail.gmail.com>	 <1249580707.14919.29.camel@mj>	 <43e72e890908061142w41d3c0e8x1dc81ffd3ac5b8ae@mail.gmail.com>	 <4A7BD15E.1030604@redfish-solutions.com>	 <43e72e890908070905s447a2fc0j2dc086048194db34@mail.gmail.com>	 <4A7CC24D.1000104@redfish-solutions.com> <1249698462.25983.7.camel@mj> <4A809B8D.5000309@redfish-solutions.com>
In-Reply-To: <4A809B8D.5000309@redfish-solutions.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Philip A. Prindeville wrote:
> * allowing a cross-compilation without contamination by the host's own state via pkg-config bleeding into it.

Setting PKG_CONFIG_LIBDIR should fix that without any makefile changes.
I haven't tried with this package, but it works for every other
cross compilation I've done.
