Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:13740 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbYCZQi6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 12:38:58 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: don't depend on IEEE80211
Date: Wed, 26 Mar 2008 17:35:59 +0100
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200803261324.21938.hs4233@mail.mn-solutions.de>
In-Reply-To: <200803261324.21938.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803261735.59235.hs4233@mail.mn-solutions.de> (sfid-20080326_163903_793127_B3ABE1D4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, please wait with applying this. I just saw that 
escape_essid is also used in debugfs.c, even when 
CONFIG_LIBERTAS_DEBUG is off.
