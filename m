Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:3033 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161AbYC0HtO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 03:49:14 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] libertas: don't depend on IEEE80211
Date: Thu, 27 Mar 2008 08:46:14 +0100
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200803261324.21938.hs4233@mail.mn-solutions.de> <200803261735.59235.hs4233@mail.mn-solutions.de> <1206553074.31383.104.camel@localhost.localdomain>
In-Reply-To: <1206553074.31383.104.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803270846.14840.hs4233@mail.mn-solutions.de> (sfid-20080327_074918_306390_030CB543)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 26 March 2008 18:37:54 Dan Williams wrote:
> Yeah, but from lbs_getscantable() which is utterly pointless
> since the only thing it provides beyond 'iwlist eth1 scan' is
> CAP_SPECTRUM_MGMT, which if people really care, we can shove
> out in custom WEXT scan result tags.   I'd just kill
> lbs_getscantable() completely.

That is the only thing from debugfs that I regularly "cat". The 
reason is that I get the current version, if I do "iwlist eth1 
scan", I get a new version of what's there.
