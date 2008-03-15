Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:55797 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbYCOSHe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Mar 2008 14:07:34 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [PATCH] [RFT] b43legacy: fix bcm4303 crash
Date: Sat, 15 Mar 2008 19:07:06 +0100
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <20080315190121.70edbfcd@morte>
In-Reply-To: <20080315190121.70edbfcd@morte>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803151907.06553.mb@bu3sch.de> (sfid-20080315_180739_442710_E6896C6F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 15 March 2008 19:01:21 Stefano Brivio wrote:
> This should fix an hard crash which happened upon driver loading on bcm4303
> rev. 2 devices. The bug was originally reported here:
> https://bugzilla.redhat.com/show_bug.cgi?id=384981.
> Please test.
> 
> This won't make bcm4303 rev. 2 devices working anyway, there still are some
> issues with initial values which I'm trying to fix.

-ENOPATCH? :)

-- 
Greetings Michael.
