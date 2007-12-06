Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:23018 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbXLFLTF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 06:19:05 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] libertas: don't cast a pointer to pointer of
Date: Thu, 6 Dec 2007 12:19:27 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <200712061154.46070.hs4233@mail.mn-solutions.de> <1196939134.3980.25.camel@localhost.localdomain>
In-Reply-To: <1196939134.3980.25.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200712061219.27171.hs4233@mail.mn-solutions.de> (sfid-20071206_111911_234549_FF0CD69E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Haven't tested it, but this looks like the right thing to do. 
> I'll probably step all over Woodhouse's command rework though.

Not yet :-)

It applied cleanly to libertas-2.6 and is already in his 
libertas-2.6 tree.
