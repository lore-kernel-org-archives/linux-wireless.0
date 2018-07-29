Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60708 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731558AbeG2Cjj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Jul 2018 22:39:39 -0400
Subject: Re: [PATCH v1] PCI: Add PCI_DEVICE_DATA() macro to fully describe
 device ID entry
To: Joe Perches <joe@perches.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
References: <20180727203914.89704-1-andriy.shevchenko@linux.intel.com>
 <597a61a1b1e0caf7770fe9109e2913708b28ac22.camel@perches.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <7c63c24f-112e-d190-883d-2647ab148c8f@infradead.org> (sfid-20180729_031241_140163_1A447482)
Date: Sat, 28 Jul 2018 18:11:00 -0700
MIME-Version: 1.0
In-Reply-To: <597a61a1b1e0caf7770fe9109e2913708b28ac22.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/28/2018 05:29 PM, Joe Perches wrote:
> On Fri, 2018-07-27 at 23:39 +0300, Andy Shevchenko wrote:
>> There are a lot of examples in the kernel where PCI_VDEVICE() is used and still
>> looks not so convenient due to additional driver_data field attached.
>>
>> Introduce PCI_DEVICE_DATA() macro to fully describe device ID entry in shortest
>> possible form. For example,
>>
>>   before:
>>
>>     { PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MRFLD),
>>       (kernel_ulong_t) &dwc3_pci_mrfld_properties, },
>>
>>   after:
>>
>>     { PCI_VDEVICE(INTEL, INTEL_MRFLD, &dwc3_pci_mrfld_properties },
> 
> PCI_DEVICE_DATA(...)
> 

see v2 and v3 :)


-- 
~Randy
