Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:1960 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbZGWIah (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 04:30:37 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Update for regulatory database on 5GHz band for Thailand (TH)
Date: Thu, 23 Jul 2009 10:31:48 +0200
Cc: David Quan <David.Quan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Michael Green <Michael.Green@atheros.com>
References: <f7de31c0907220607v3266710co5640389fc0ccbc22@mail.gmail.com> <15B47C78534E094AA9A41F58FB8D74F30147BE67876F@SC1EXMB-MBCL.global.atheros.com> <43e72e890907220941j70f5ca98g5af9d9372eeef2e@mail.gmail.com>
In-Reply-To: <43e72e890907220941j70f5ca98g5af9d9372eeef2e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200907231031.48801.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>         (5170 - 5250 @ 20), (3, 17)
>         (5250 - 5330 @ 20), (3, 20), DFS

Is it an error to have the same frequency listed twice (once in 
the "from" column, once in the "till" column?  And if yes, does 
frequency 5250 get's assigned "(3, 17)" or "(3, 20), DFS" ???

If it's an error, then maybe the regdb-compiler should emit a 
warning about this.

-- 
http://www.holgerschurig.de
