Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:38891 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab3LGWWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Dec 2013 17:22:47 -0500
Message-ID: <52A39F18.8080202@broadcom.com> (sfid-20131207_232257_813175_DB0E4B9F)
Date: Sat, 7 Dec 2013 23:20:08 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [net] nfc: Fix FSF address in file headers
References: <1386348976-24657-1-git-send-email-jeffrey.t.kirsher@intel.com>
In-Reply-To: <1386348976-24657-1-git-send-email-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/06/2013 05:56 PM, Jeff Kirsher wrote:
> Several files refer to an old address for the Free Software Foundation
> in the file header comment.  Resolve by replacing the address with
> the URL<http://www.gnu.org/licenses/>  so that we do not have to keep
> updating the header comments anytime the address changes.

This seems to pop up from time to time and unfortunately the resolution 
seems not consistent at those times. Why not simply refer to the full 
license text that is in the COPYING file in the tree itself.

Regards,
Arend

> CC:linux-wireless@vger.kernel.org
> CC: Lauro Ramos Venancio<lauro.venancio@openbossa.org>
> CC: Aloisio Almeida Jr<aloisio.almeida@openbossa.org>
> CC: Samuel Ortiz<sameo@linux.intel.com>
> Signed-off-by: Jeff Kirsher<jeffrey.t.kirsher@intel.com>

