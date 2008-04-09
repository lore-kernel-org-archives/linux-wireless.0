Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:28604 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbYDIICo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 04:02:44 -0400
Received: from lin01.mn-solutions.de (pD95FBA15.dip0.t-ipconnect.de [217.95.186.21])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id 704B45E4022
	for <linux-wireless@vger.kernel.org>; Wed,  9 Apr 2008 10:02:41 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 72E761E000E
	for <linux-wireless@vger.kernel.org>; Wed,  9 Apr 2008 09:59:47 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [ANN] WiMAX stack and drivers for Intel WiMAX Link 5050
Date: Wed, 9 Apr 2008 09:59:47 +0200
References: <200804011107.38563.inaky@linux.intel.com> <20080408135601.5dad3566@speedy> <200804081359.03611.inaky@linux.intel.com>
In-Reply-To: <200804081359.03611.inaky@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804090959.47619.hs4233@mail.mn-solutions.de> (sfid-20080409_090251_129231_CA5CB200)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > 9. Anyway to reuse existing usbnet infrastructure?
>
> Nope, the 2400 is a pure IP device (as Marcel mentioned).

With "pure IP", do you mean IPv4?  Or do you mean "pure 
IPv4/IPv6"?  If it is "pure IPv4", then WiMAX seems not future 
proof ...
