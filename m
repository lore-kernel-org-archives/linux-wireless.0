Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:9722 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbXFDM2b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2007 08:28:31 -0400
Received: from lin01.mn-solutions.de (pD95F9AAC.dip0.t-ipconnect.de [217.95.154.172])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id 9EFBD5E586F
	for <linux-wireless@vger.kernel.org>; Mon,  4 Jun 2007 14:28:30 +0200 (CEST)
Received: from mnz66.mn-solutions.de.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id D102F1E002B
	for <linux-wireless@vger.kernel.org>; Mon,  4 Jun 2007 14:28:25 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: AW: Drivers that do not honor regulatory restrictions
Date: Mon, 4 Jun 2007 14:28:25 +0200
References: <297494.10588.qm@web51404.mail.re2.yahoo.com>
In-Reply-To: <297494.10588.qm@web51404.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200706041428.25375.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 1575         { 2412, 2484, 20, 6 } /* IEEE 802.11b/g, channels
> 1..13 */,
>
> did the trick.

Not sure if that is the right place .... but if you change the 
frequency, you should also change the comment:

     /* IEEE 802.11b/g, channels 1..14 */

would be better.
