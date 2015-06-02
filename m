Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50311 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751374AbbFBHr1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 03:47:27 -0400
Message-ID: <1433231239.17081.0.camel@coelho.fi> (sfid-20150602_094731_063717_2320E361)
From: Luca Coelho <luca@coelho.fi>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 02 Jun 2015 10:47:19 +0300
In-Reply-To: <1432907257.6319.50.camel@decadent.org.uk>
References: <1432905874.11687.4.camel@coelho.fi>
	 <1432907257.6319.50.camel@decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: debian: crda package depends on iw?
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 2015-05-29 at 14:47 +0100, Ben Hutchings wrote:
> On Fri, 2015-05-29 at 16:24 +0300, Luca Coelho wrote:
> > Hi Ben,
> > 
> > I just noticed that the crda package depends on the iw package in Debian
> > (I'm using jessie):
> > 
> > luca@weizen:~$ apt-cache show crda
> > Package: crda
> > Version: 3.13-1
> > Installed-Size: 293
> > Maintainer: Ben Hutchings <ben@decadent.org.uk>
> > Architecture: amd64
> > Depends: libc6 (>= 2.7), libnl-3-200 (>= 3.2.7), libnl-genl-3-200 (>= 3.2.7), libssl1.0.0 (>= 1.0.0), wireless-regdb, iw (>= 3.2-1~)
> > Description-en: wireless Central Regulatory Domain Agent
> >  This package provides a Central Regulatory Domain Agent (CRDA) to be used by
> >  the Linux kernel cfg80211 wireless subsystem to query and apply the regulatory
> >  domain settings wireless devices may operate within for a given location.
> >  .
> >  CRDA queries operational frequency regulations stored within the regulatory
> >  database provided by the wireless-regdb package.
> > Description-md5: bacfc9c20ed2cf2120d3c95c8e749666
> > Multi-Arch: foreign
> > Homepage: http://wireless.kernel.org/en/developers/Regulatory/CRDA
> > Tag: role::program
> > Section: net
> > Priority: optional
> > Filename: pool/main/c/crda/crda_3.13-1_amd64.deb
> > Size: 59958
> > MD5sum: 6eacfbb62c7647ee3bba653ee5adfe70
> > SHA1: 0f02aebc61f68b87189c867369dbd5df74f4e5ca
> > SHA256: 52d114e826944a492d68b3e4e77aed0feeee9c28f6a7c3d5c587027eb283f2cc
> > 
> > Is there a specific reason for this or is it just accidental?
> 
> setregdomain is a script that runs iw.

Ah, okay, thanks for clarifying! I wasn't expecting this dependency.

--
Cheers,
Luca.

