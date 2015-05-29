Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48089 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753234AbbE2NoN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2015 09:44:13 -0400
Message-ID: <1432905874.11687.4.camel@coelho.fi> (sfid-20150529_154417_868127_732753CF)
From: Luca Coelho <luca@coelho.fi>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 29 May 2015 16:24:34 +0300
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: debian: crda package depends on iw?
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

I just noticed that the crda package depends on the iw package in Debian
(I'm using jessie):

luca@weizen:~$ apt-cache show crda
Package: crda
Version: 3.13-1
Installed-Size: 293
Maintainer: Ben Hutchings <ben@decadent.org.uk>
Architecture: amd64
Depends: libc6 (>= 2.7), libnl-3-200 (>= 3.2.7), libnl-genl-3-200 (>= 3.2.7), libssl1.0.0 (>= 1.0.0), wireless-regdb, iw (>= 3.2-1~)
Description-en: wireless Central Regulatory Domain Agent
 This package provides a Central Regulatory Domain Agent (CRDA) to be used by
 the Linux kernel cfg80211 wireless subsystem to query and apply the regulatory
 domain settings wireless devices may operate within for a given location.
 .
 CRDA queries operational frequency regulations stored within the regulatory
 database provided by the wireless-regdb package.
Description-md5: bacfc9c20ed2cf2120d3c95c8e749666
Multi-Arch: foreign
Homepage: http://wireless.kernel.org/en/developers/Regulatory/CRDA
Tag: role::program
Section: net
Priority: optional
Filename: pool/main/c/crda/crda_3.13-1_amd64.deb
Size: 59958
MD5sum: 6eacfbb62c7647ee3bba653ee5adfe70
SHA1: 0f02aebc61f68b87189c867369dbd5df74f4e5ca
SHA256: 52d114e826944a492d68b3e4e77aed0feeee9c28f6a7c3d5c587027eb283f2cc

Is there a specific reason for this or is it just accidental?

--
Cheers,
Luca.

