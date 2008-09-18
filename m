Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:61105 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbYIRUqU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 16:46:20 -0400
Received: by yx-out-2324.google.com with SMTP id 8so23106yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 13:46:19 -0700 (PDT)
Message-ID: <43e72e890809181346o22793701r21d594ee79d6954c@mail.gmail.com> (sfid-20080918_224624_203418_85CB4F3E)
Date: Thu, 18 Sep 2008 13:46:19 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: What is the state of 802.11h support?
Cc: "Gordon, Charles" <Charles.Gordon@digi.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240809181323n2fba2c93j7e884a437efbfe58@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <8DCC153EAFE67A4B990A840E829F704B718874D96D@mtk-sms-exch01.digi.com>
	 <1ba2fa240809181323n2fba2c93j7e884a437efbfe58@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 18, 2008 at 1:23 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Thu, Sep 18, 2008 at 5:31 PM, Gordon, Charles
> <Charles.Gordon@digi.com> wrote:
>> Can someone tell me how much of 802.11h is supported by Linux?  What is the plan for completing it enough so that it implements a client which complies with the specification?
>>
>> What needs to be implemented in the wireless NIC driver to support 802.11h?  My company is working on a wireless NIC driver for Linux.
>>
> What part of 11h are you looking for. We have pending implementation
> for everything that is under must requirement for BSS mode. Radar
> detection is not implemented.

Please post the patches, even if its in a temp directory.

  Luis
