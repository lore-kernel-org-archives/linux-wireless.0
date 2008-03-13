Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:5393 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbYCMPHs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2008 11:07:48 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH, take 2] libertas: convert GET_LOG to a direct command
Date: Thu, 13 Mar 2008 16:04:53 +0100
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200803131010.32763.hs4233@mail.mn-solutions.de> <1205419021.23812.8.camel@localhost.localdomain>
In-Reply-To: <1205419021.23812.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803131604.54033.hs4233@mail.mn-solutions.de> (sfid-20080313_150757_272006_252FFB98)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Sound OK?

Generally ok. Do you want this in "incremental" style, as a patch 
on top of this one?  Or do you want a more radical patch 
replacing this one ?
