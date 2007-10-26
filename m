Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:7520 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbXJZLnx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 07:43:53 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] move wlan_*_association_work from header to c file
Date: Fri, 26 Oct 2007 13:43:51 +0200
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	Dan Williams <dcbw@redhat.com>
References: <200710111151.06989.hs4233@mail.mn-solutions.de> <1193073620.4325.7.camel@localhost.localdomain> <200710251037.50057.hs4233@mail.mn-solutions.de>
In-Reply-To: <200710251037.50057.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710261343.51684.hs4233@mail.mn-solutions.de> (sfid-20071026_124355_926421_BD02CA88)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John !

wireless-2.6/everything is a moving target. The two patches I've 
sent yesterday no longer apply cleanly. So I've made them new.

Because of the sheer size of one of them, I've put them there:

http://git.infradead.org/?p=users/schurig/libertas-cleanup.git;a=shortlog;h=cleanup


Please apply.
