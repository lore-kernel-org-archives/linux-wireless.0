Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:43179 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030501AbXDKXZI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2007 19:25:08 -0400
Message-ID: <461D6E4F.6060401@warmcat.com>
Date: Thu, 12 Apr 2007 00:25:03 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: Simon Barber <simon@devicescape.com>,
	Michael Wu <flamingice@sourmilk.net>,
	mabbas <mabbas@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <jkm@devicescape.com>
Subject: Re: [patch 2/5] Add basic support for IEEE 802.11n discovery and  association
References: <1174909105.1364.53.camel@dell-4965.jf.intel.com>	 <20070411194059.GA2436@tuxdriver.com> <461D3F48.70004@linux.intel.com>	 <200704111630.06160.flamingice@sourmilk.net>	 <1ba2fa240704111503l6dcef504na73c997ae75ebccd@mail.gmail.com>	 <C86180A8C204554D8A3323D8F6B0A29F01DEB33D@dhost002-46.dex002.intermedia.net> <1ba2fa240704111605l305230d3vf09c085473364eb3@mail.gmail.com>
In-Reply-To: <1ba2fa240704111605l305230d3vf09c085473364eb3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler wrote:

> So you monitor your traffic load in driver, then notify user space
> application which opens or tears down for you the BA stream?
> What would be the notification mechanism ?

Since hopefully the concept will involve a kernelside-filtered 
monitoring action via libpcap, the stack could for example inject a 
periodic stats summary packet down the monitor interface back to userspace.

-Andy
