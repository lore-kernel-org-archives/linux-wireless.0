Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from L01SLCSMTP02.calltower.com ([69.4.184.249]:17626 "EHLO
	L01SLCSMTP02.calltower.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750906AbZHFTWI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 15:22:08 -0400
Subject: Re: CRDA and cross-compilation
From: Jon Loeliger <jdl@bigfootnetworks.com>
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Cc: Pavel Roskin <proski@gnu.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4A7B2B7A.5030802@redfish-solutions.com>
References: <4A7A8F7E.6020503@redfish-solutions.com>
	 <1249569993.6446.2.camel@jdl-desktop>  <1249576886.14919.16.camel@mj>
	 <43e72e890908060956j3548c23ak4cf98d11c32efec0@mail.gmail.com>
	 <1249580707.14919.29.camel@mj>  <4A7B2B7A.5030802@redfish-solutions.com>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 14:21:54 -0500
Message-Id: <1249586514.6446.12.camel@jdl-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-08-06 at 12:14 -0700, Philip A. Prindeville wrote:

> 
> Can someone roll *all* the patches together?  For instance, "pkg-config" shouldn't be used on a cross-compile...
> 
> -Philip


Philip,

These are the sorts of issues that made my patch seem
more complicated than first blush might suggest was needed.

jdl


