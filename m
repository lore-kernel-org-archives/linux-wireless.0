Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:10224 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbXJHJrw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2007 05:47:52 -0400
Received: from lin01.mn-solutions.de (pD95F8393.dip0.t-ipconnect.de [217.95.131.147])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id 2D2918B046B
	for <linux-wireless@vger.kernel.org>; Mon,  8 Oct 2007 11:47:51 +0200 (CEST)
Received: from mnz66.mn-solutions.de.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id DF1141E002B
	for <linux-wireless@vger.kernel.org>; Mon,  8 Oct 2007 11:44:55 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: fix "warning: Using plain integer as NULL pointer" sparse warnings
Date: Mon, 8 Oct 2007 11:47:59 +0200
References: <200710081141.23237.hs4233@mail.mn-solutions.de>
In-Reply-To: <200710081141.23237.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710081148.00041.hs4233@mail.mn-solutions.de> (sfid-20071008_104759_880773_6B6B7D7A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hmm, I had "wordwrap" turned on :-(

checkpatch.pl barks on this patch anyway, because of the
ridiculus 80 columns restriction it wants to impose. Should I 
rephrase the patch because of this or just ignore this 
checkpatch warning?
