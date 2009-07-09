Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:16427 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbZGIHLM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 03:11:12 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [regression] ath5k: Overrides regulatory domain set for cfg80211
Date: Thu, 9 Jul 2009 09:11:07 +0200
Cc: Frans Pop <elendil@planet.nl>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, netdev@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200907082340.07787.elendil@planet.nl> <43e72e890907081508n6fa5781an1dcbda078efc5379@mail.gmail.com> <200907090311.40205.elendil@planet.nl>
In-Reply-To: <200907090311.40205.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200907090911.07648.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> For Debian iw is available in testing/unstable, but not in
> stable.

Make an effort to get it into backports.org ....   and AFAIK, 
Kernel 2.6.30xxx isn't in Debian stable either. So by using a 
different kernel you've moved away from a purely "Debian stable" 
setup anyway.

-- 
http://www.holgerschurig.de
