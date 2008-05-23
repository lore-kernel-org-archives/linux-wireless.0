Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:6927 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbYEWL1m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 07:27:42 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: fix compact flash interrupt handling
Date: Fri, 23 May 2008 13:27:26 +0200
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200805231010.48939.hs4233@mail.mn-solutions.de>
In-Reply-To: <200805231010.48939.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805231327.26652.hs4233@mail.mn-solutions.de> (sfid-20080523_132744_011144_2A68C1F2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hmm, I'm not sure if I found a regression with this patch, so 
hold it for now. I also think that splitting this patch into two 
should also be done.
