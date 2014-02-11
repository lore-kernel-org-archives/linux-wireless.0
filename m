Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:57074 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaBKHVt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 02:21:49 -0500
Date: Tue, 11 Feb 2014 18:21:28 +1100
From: James Cameron <quozl@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Subject: Re: [PATCH v2 08/30] mwifiex: implement extended scan feature
Message-ID: <20140211072128.GR5487@us.netrek.org> (sfid-20140211_082152_770345_8AAF7641)
References: <1391819017-20995-1-git-send-email-bzhao@marvell.com>
 <1391819017-20995-4-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1391819017-20995-4-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 07, 2014 at 04:23:37PM -0800, Bing Zhao wrote:
> [...]
> @@ -1925,6 +1943,167 @@ check_next_scan:
>  }
>  
>  /*
> + * This function prepares an extended scan command to be sent to the firmware
> + *
> + * This uses the scan command configiguration sent to the command processing

                                      ^

trivial typo, should be "configuration".

-- 
James Cameron
http://quozl.linux.org.au/
