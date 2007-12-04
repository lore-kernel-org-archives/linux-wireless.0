Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:7302 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbXLDKxL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 05:53:11 -0500
Received: from lin01.mn-solutions.de (pD95F94BA.dip0.t-ipconnect.de [217.95.148.186])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id 2041B5E4115
	for <linux-wireless@vger.kernel.org>; Tue,  4 Dec 2007 11:53:09 +0100 (CET)
Received: from mnz66.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id EC0E31E00FD
	for <linux-wireless@vger.kernel.org>; Tue,  4 Dec 2007 11:50:15 +0100 (CET)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: questions regarding removing the depencency on CONFIG_IEEE80211
Date: Tue, 4 Dec 2007 11:53:24 +0100
References: <200712041140.07516.hs4233@mail.mn-solutions.de>
In-Reply-To: <200712041140.07516.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712041153.24896.hs4233@mail.mn-solutions.de> (sfid-20071204_105315_872371_0254E00F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

7. escape_ssid()

This code from ieee80211 is used in various debug messages.
Should I re-implement this locally in the driver?
