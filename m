Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:58354 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbZLAJwj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 04:52:39 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: remove internal buffers from GSPI driver
Date: Tue, 1 Dec 2009 10:52:13 +0100
Cc: Colin McCabe <cmccabe@alumni.cmu.edu>,
	Andrey Yurovsky <andrey@cozybit.com>, dcbw@redhat.com,
	sebatian@breakpoint.cc, libertas-dev@lists.infradead.org
References: <1256687501-8636-1-git-send-email-andrey@cozybit.com> <436f52800911301653q224bacceq4a14cbbfaa5cc0e2@mail.gmail.com>
In-Reply-To: <436f52800911301653q224bacceq4a14cbbfaa5cc0e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200912011052.13643.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Perhaps the easiest thing would be to get rid of this usage of
> hw_host_to_card? 

That would mean to rewrite this not only for SPI, but also for
USB and CS. If you come up with patches, I'm willing to test this
against USB and/or CS, in case you don't have this hardware.

-- 
http://www.holgerschurig.de
