Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4966 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688Ab2FMN3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 09:29:47 -0400
Message-ID: <4FD895B7.8030105@broadcom.com> (sfid-20120613_152952_655147_F8747008)
Date: Wed, 13 Jun 2012 15:29:27 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Linux Wireless List" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 5/5] brcmfmac: introduce checkdied debugfs
 functionality
References: <1339275105-3593-1-git-send-email-arend@broadcom.com>
 <1339275105-3593-6-git-send-email-arend@broadcom.com>
 <CA+XFjioPG4aT-umi1BD+RH0q0a3AEY=QXTAFapGhz3x25cLdSw@mail.gmail.com>
 <4FD42939.2020404@broadcom.com>
 <CA+XFjioaw4Bmxd_Wy_hjWO4G+LWWx4YmRAMFEgU4H_hFdoRVuw@mail.gmail.com>
In-Reply-To: <CA+XFjioaw4Bmxd_Wy_hjWO4G+LWWx4YmRAMFEgU4H_hFdoRVuw@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/10/2012 07:14 AM, Gábor Stefanik wrote:
> On Sun, Jun 10, 2012 at 6:57 AM, Arend van Spriel <arend@broadcom.com> wrote:
>> On 06/10/2012 04:13 AM, Gábor Stefanik wrote:
>>> On Sat, Jun 9, 2012 at 10:51 PM, Arend van Spriel <arend@broadcom.com> wrote:
>>>>
>>>> +/* Device console log buffer state */
>>>> +#define CONSOLE_BUFFER_MAX     2024
>>>
>>> Just out of curiosity; what is the significance of this number?
>>
>> It is used in the code fragment below. I have to admit the comment is
>> not explaining its significance.
> 
> But why this particular number? Did you mean 2048?
> 

Not sure. Maybe the console info has 24 bytes overhead leaving 2024
bytes of raw buffer data, but I can only guess.

Gr. AvS

