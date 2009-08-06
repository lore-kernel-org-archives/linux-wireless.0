Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:50068 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbZHFTII (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 15:08:08 -0400
Subject: Re: CRDA and cross-compilation
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Jon Loeliger <jdl@bigfootnetworks.com>,
	"Philip A. Prindeville" <philipp_subx@redfish-solutions.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890908061142w41d3c0e8x1dc81ffd3ac5b8ae@mail.gmail.com>
References: <4A7A8F7E.6020503@redfish-solutions.com>
	 <1249569993.6446.2.camel@jdl-desktop>  <1249576886.14919.16.camel@mj>
	 <43e72e890908060956j3548c23ak4cf98d11c32efec0@mail.gmail.com>
	 <1249580707.14919.29.camel@mj>
	 <43e72e890908061142w41d3c0e8x1dc81ffd3ac5b8ae@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 15:08:04 -0400
Message-Id: <1249585684.19169.12.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-08-06 at 11:42 -0700, Luis R. Rodriguez wrote:

> > -all: $(REG_BIN) crda intersect verify
> > +all: all_noverify verify
> > +
> > +all_noverify: crda intersect regdbdump
> 
> You removed REG_BIN from here, was that intentional?

Yes.  It's not needed for the build.  As for the "verify" target, it
already depends on $(REG_BIN)

-- 
Regards,
Pavel Roskin
