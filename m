Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22556 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbbHRJPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 05:15:32 -0400
Date: Tue, 18 Aug 2015 12:15:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: =?iso-8859-1?Q?Rapha=EBl?= Beamonte <raphael.beamonte@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Arend van Spriel <arend@broadcom.com>
Subject: Re: [PATCHv3] staging: wilc1000: replace MALLOC_WILC_BUFFER() macro
 to avoid possible memory leak
Message-ID: <20150818091530.GH5610@mwanda> (sfid-20150818_111548_378416_11AA510E)
References: <55D238D4.20800@broadcom.com>
 <ba3c67af8cbe5658154084a165785c637e5a2bc8.1439853139.git.raphael.beamonte@gmail.com>
 <20150817234628.GK5558@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150817234628.GK5558@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To be honest, I have lost track of this patchset.  If you are planning
to redo the other patches can you send it in a new thread?

regards,
dan carpenter

