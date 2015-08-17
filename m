Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32395 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbbHQXqf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 19:46:35 -0400
Date: Tue, 18 Aug 2015 02:46:28 +0300
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
Message-ID: <20150817234628.GK5558@mwanda> (sfid-20150818_014651_014872_43D9767C)
References: <55D238D4.20800@broadcom.com>
 <ba3c67af8cbe5658154084a165785c637e5a2bc8.1439853139.git.raphael.beamonte@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <ba3c67af8cbe5658154084a165785c637e5a2bc8.1439853139.git.raphael.beamonte@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 17, 2015 at 07:12:47PM -0400, Raphaël Beamonte wrote:
> The MALLOC_WILC_BUFFER() macro was using a return statement, and didn't
> take care of possible memory leaks and subsequent bugs when it was failing
> after succeeding some allocations. This patch corrects this behavior.
> 
> Signed-off-by: Raphaël Beamonte <raphael.beamonte@gmail.com>
> ---

Yes.  This looks good now.

regards,
dan carpenter

