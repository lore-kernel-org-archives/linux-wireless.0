Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47261 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973AbZGGPAv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 11:00:51 -0400
Date: Tue, 7 Jul 2009 10:48:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Ross <dave@antacs.com>
Cc: Valentin Manea <linux-wireless@mrs.ro>,
	linux-wireless@vger.kernel.org
Subject: Re: mac80211 and broadcast frames
Message-ID: <20090707144851.GA2768@tuxdriver.com>
References: <4A49EEC3.3060108@mrs.ro> <43e72e890906300920j1963ae07v800468db9a908a1@mail.gmail.com> <4A4B056B.9000602@mrs.ro> <43e72e890907011033r52c4256dtecf603f56213a825@mail.gmail.com> <4A530131.9050207@mrs.ro> <4A532D3C.5060601@antacs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4A532D3C.5060601@antacs.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 07, 2009 at 09:10:52PM +1000, David Ross wrote:
> Actually it is required to be a mutual BASIC rate (not extended rates) -  
> not necessarily the "lowest possible" - David.

True, but FWIW I think all of our rate scaling algorithms choose the
lowest rate.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
