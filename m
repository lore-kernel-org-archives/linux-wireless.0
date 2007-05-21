Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:20180 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011AbXEUVHU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2007 17:07:20 -0400
Message-ID: <46520ABC.1070604@oracle.com>
Date: Mon, 21 May 2007 14:10:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: "Cohen, Guy" <guy.cohen@intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	James Ketrenos <jketreno@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers [part 2/2]
References: <D0122E209EBF8D4CAB38EC6A8AF244E5028B1C2D@hasmsx412.ger.corp.intel.com> <465208CA.8090201@garzik.org>
In-Reply-To: <465208CA.8090201@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jeff Garzik wrote:
> Cohen, Guy wrote:
>> Support for big-endian platforms (as well as AP mode) for iwlwifi is
>> currently *planned* to be added by Intel in the near future for several
>> purposes.
> 
>> However, the vast majority of iwlwifi users at this point run it over
>> little-endian platforms. _Delaying_ the inclusion of iwlwifi driver will
>> not assist iwlwifi-over-big-endian-platform users in any way, but the
>> impact on the rest of the users is clear.
> 
> 
> All Linux drivers that use the proper APIs are transparently portable to 
> either little endian or big endian, 32-bit or 64-bit machines.
> 
> If your driver is not portable, then it is not using the proper APIs, 
> and needs updating.
> 
> Next time, write the driver using the correct APIs and you will not run 
> into these sort of problems...

Ack.  Basically same idea for coding style issues also.
Do it right the first time, don't have to redo it.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
