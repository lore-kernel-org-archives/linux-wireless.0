Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15298 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757578AbXEUVoP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2007 17:44:15 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH]  Add iwlwifi wireless drivers [part 2/2]
Date: Tue, 22 May 2007 00:43:55 +0300
Message-ID: <D0122E209EBF8D4CAB38EC6A8AF244E5028B1C57@hasmsx412.ger.corp.intel.com>
In-Reply-To: <46520ABC.1070604@oracle.com>
From: "Cohen, Guy" <guy.cohen@intel.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>,
	"Jeff Garzik" <jeff@garzik.org>
Cc: "Christoph Hellwig" <hch@infradead.org>,
	"James Ketrenos" <jketreno@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



From: Randy Dunlap [mailto:randy.dunlap@oracle.com]
>Jeff Garzik wrote:
>> Cohen, Guy wrote:
>>> Support for big-endian platforms (as well as AP mode) for iwlwifi is
>>> currently *planned* to be added by Intel in the near future for
several
>>> purposes.
>>
>>> However, the vast majority of iwlwifi users at this point run it
over
>>> little-endian platforms. _Delaying_ the inclusion of iwlwifi driver
will
>>> not assist iwlwifi-over-big-endian-platform users in any way, but
the
>>> impact on the rest of the users is clear.
>>
>>
>> All Linux drivers that use the proper APIs are transparently portable
to
>> either little endian or big endian, 32-bit or 64-bit machines.
>>
>> If your driver is not portable, then it is not using the proper APIs,
>> and needs updating.
>>
>> Next time, write the driver using the correct APIs and you will not
run
>> into these sort of problems...
>
>Ack.  Basically same idea for coding style issues also.
>Do it right the first time, don't have to redo it.
>

You two are right. Any other reply from my side will be dumb... We will
learn the lesson...

But at this point (we can't change the past nor the present), we would
like to focus on more urgent issues with iwlwifi in the immediate term
and delay a bit the big-endian support. Is this acceptable?

>--
>~Randy
>*** Remember to use Documentation/SubmitChecklist when testing your
code
>***
