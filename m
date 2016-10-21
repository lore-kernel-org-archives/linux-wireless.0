Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:37275 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932941AbcJUM45 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 08:56:57 -0400
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        Jonathan Corbet <corbet@lwn.net>
Cc: linux-wireless@vger.kernel.org,
        linux-doc <linux-doc@vger.kernel.org>,
        Markus Heiser <markus.heiser@darmarit.de>
Subject: Re: sequence diagrams in rst documentation
In-Reply-To: <1477053099.4068.42.camel@sipsolutions.net>
References: <1476190613-2403-1-git-send-email-johannes@sipsolutions.net> <20161011072119.7ad4e3a3@lwn.net> <1476193466.4118.10.camel@sipsolutions.net> <1476194038.4118.11.camel@sipsolutions.net> <1476791021.6425.25.camel@sipsolutions.net> <20161018175236.75c8c4e2@lwn.net> <1476863488.5927.10.camel@sipsolutions.net> <1477053099.4068.42.camel@sipsolutions.net>
Date: Fri, 21 Oct 2016 15:56:54 +0300
Message-ID: <87k2d1q2qx.fsf@intel.com> (sfid-20161021_145704_504687_0EA9075C)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 21 Oct 2016, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > 	https://pythonhosted.org/sphinxcontrib-aafig/
>> > 
>> > I've not actually played with it at all, but I like the idea that
>> > we'd have readable diagrams in the source docs as well...
>> 
>> Well, maybe. I agree having it readable in the source docs as well is
>> nice, but for sequence diagrams in particular, I don't think
>> 
>>     +-------+         +-----------+
>>     | Hello +-------->+ aafigure! |
>>     +-------+         +-----------+
>> 
>> really beats
>> 
>>    Hello -> aafigure!
>
>
> I found another one:
>
> https://pypi.python.org/pypi/sphinxcontrib-plantuml
>
> That one has really nice output and features, but ends up being a
> *java* (of all the things) tool that the thing calls out to ...
>
>
> Perhaps we can have a compromise and embed the raw text when the
> tooling isn't all installed, so you can still build useful
> documentation, but to get all the "prettiness" you might have to
> install more dependencies?

I had the same conclusion for math:: directives pulling in latex
dependency [1]. Hopefully Markus can help here.

BR,
Jani.


[1] http://lkml.kernel.org/r/877f93qdd2.fsf@intel.com



-- 
Jani Nikula, Intel Open Source Technology Center
