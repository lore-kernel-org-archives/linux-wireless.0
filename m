Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56803.mail.re3.yahoo.com ([66.196.97.77]:33532 "HELO
	web56803.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753465Ab0LWTFk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Dec 2010 14:05:40 -0500
Message-ID: <142357.30253.qm@web56803.mail.re3.yahoo.com>
Date: Thu, 23 Dec 2010 11:05:39 -0800 (PST)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: carl9170 and debian squeeze
To: linux-wireless@vger.kernel.org, Der Engel <engelster@gmail.com>
In-Reply-To: <AANLkTimDPcxSthO=TAqPx4fyrU0U_WPkwMHLGGiCSMKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Any ideas how can I make carl9170.fw work in debian
> squeeze?

Download and install compat-wireless. Then blacklist ar9170 and call carl9170 instead.

Walter


      
